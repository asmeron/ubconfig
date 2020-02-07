#!/bin/bash

diff tail.txt $1 | grep '>' | cut -d' ' --complement -f1