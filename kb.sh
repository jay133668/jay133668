#!/bin/bash

def remove_rc_pkg {
dpkg -l | grep ^rc | cut -d' ' -f3 | sudo xargs dpkg --purge
}

