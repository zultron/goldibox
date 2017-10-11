#!/usr/bin/python

import sys
import os
import subprocess
import argparse
import time
from machinekit import launcher
from machinekit import config

os.chdir(os.path.dirname(os.path.realpath(__file__)))

parser = argparse.ArgumentParser(
    description='Start the Goldilocks Incubator')
parser.add_argument(
    '-nc', '--no_config',
    help='Disables the config server', action='store_true')
parser.add_argument(
    '-s', '--halscope',
    help='Starts the halscope', action='store_true')
parser.add_argument(
    '-m', '--halmeter',
    help='Starts the halmeter', action='store_true')
parser.add_argument(
    '-d', '--debug',
    help='Enable debug mode', action='store_true')
parser.add_argument(
    '-b', '--board',
    help=('Select board: sim (default), or BeagleBone varieties:  '
          'bb (black or white), pocket'),
    default='sim', choices=('sim','bb','pocket'))

args = parser.parse_args()

if args.debug:
    launcher.set_debug_level(5)

if 'MACHINEKIT_INI' not in os.environ:  # export for package installs
    mkconfig = config.Config()
    os.environ['MACHINEKIT_INI'] = mkconfig.MACHINEKIT_INI

try:
    # Start syslog, dbus and avahi services if they aren't already running
    for svc in ('rsyslog', 'dbus', 'avahi-daemon'):
        ret = subprocess.call(
            ['/usr/bin/sudo', '/etc/init.d/%s' % svc, 'status'])
        if ret != 0:
            ret = subprocess.call(
                ['/usr/bin/sudo', '/etc/init.d/%s' % svc, 'start'])

    launcher.check_installation()
    # kill any running Machinekit instances
    launcher.cleanup_session()
    if args.board != 'sim':
        # load a BeagleBone universal overlay file
        launcher.load_bbio_file('incubator-overlay-%s.bbio' % args.board)
    # start Machinekit realtime environment
    launcher.start_realtime()
    # load the main HAL file
    launcher.load_hal_file('incubator-%s.hal' % args.board)
    # enable on ctrl-C, needs to executed after HAL files
    launcher.register_exit_handler()

    # ensure mklauncher is started
    launcher.ensure_mklauncher()

    if not args.no_config:
        # start the configserver with Machineface an Cetus user interfaces
        launcher.start_process(
            "configserver -n Incubator %s ." % ('-d' if args.debug else ''))
    if args.halscope:
        # load scope only now - because all sigs are now defined:
        launcher.start_process('halscope')
    if args.halmeter:
        launcher.start_process('halmeter')

    while True:
        launcher.check_processes()
        time.sleep(1)

except subprocess.CalledProcessError:
    launcher.end_session()
    sys.exit(1)

sys.exit(0)
