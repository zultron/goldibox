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
    description='Start the Goldibox')
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
    '-r', '--run',
    help='Run app (otherwise run launcher)', action='store_true')
parser.add_argument(
    '-d', '--debug',
    help='Enable debug mode', action='store_true')
parser.add_argument(
    '-b', '--board',
    help=('Select board: simulator, PocketBeagle or autodetect'),
    default='detect', choices=('sim','pb','detect'))

args = parser.parse_args()

if args.debug:
    launcher.set_debug_level(5)

if args.board == 'detect':
    if os.getenv('GOLDIBOX_SIM',False):
        args.board = 'sim'
    elif os.path.exists('/proc/device-tree/model'):
        with open('/proc/device-tree/model','r') as f:  m=f.read()
        if 'PocketBeagle' in m:
            args.board = 'pb'
    if args.board == 'detect':
        parser.print_help()
        sys.stderr.write(
            "Error:  Unable to detect board; please specify the '-b' option\n")
        sys.exit(1)

if 'MACHINEKIT_INI' not in os.environ:  # export for package installs
    mkconfig = config.Config()
    os.environ['MACHINEKIT_INI'] = mkconfig.MACHINEKIT_INI

try:
    if not args.run:
        if args.board == 'sim':
            # Start syslog, dbus and avahi services if they aren't
            # already running in container
            for svc in ('rsyslog', 'dbus', 'avahi-daemon'):
                ret = subprocess.call(
                    ['/usr/bin/sudo', '/etc/init.d/%s' % svc, 'status'])
                if ret != 0:
                    ret = subprocess.call(
                        ['/usr/bin/sudo', '/etc/init.d/%s' % svc, 'start'])

        launcher.check_installation()
        if False:
            # kill any running Machinekit instances
            launcher.cleanup_session()

        if args.board != 'sim':
            # load a BeagleBone universal overlay file
            launcher.load_bbio_file('goldibox-overlay-%s.bbio' % args.board)

        # start Machinekit realtime environment
        launcher.start_realtime()
        # load the remote comp HAL file
        launcher.load_hal_file('goldibox-remote.py')
        # load the main HAL file
        launcher.load_hal_file('goldibox-%s.hal' % args.board)

        # enable on ctrl-C, needs to executed after HAL files
        launcher.register_exit_handler()

        # ensure mklauncher is started
        # FIXME MK PR?
        # launcher.ensure_mklauncher(debug=args.debug)
        launcher.ensure_mklauncher()

        if not args.no_config:
            # start the configserver with Machineface
            launcher.start_process(
                "exec configserver -n Goldibox%s %s ." % (
                    '-sim' if args.board == 'sim' else '',
                    '-d' if args.debug else ''))
    else:

        if args.halscope:
            # load scope only now - because all sigs are now defined:
            launcher.start_process('halscope')
        if args.halmeter:
            launcher.start_process('halmeter')

    while True:
        launcher.check_processes()
        time.sleep(1)

except subprocess.CalledProcessError as e:
    sys.stderr.write("Subprocess error:  %s\n" % e)
    if not args.run:
        launcher.end_session()
    sys.exit(1)

sys.exit(0)
