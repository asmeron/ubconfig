#!/bin/bash

ls -sh $1 | cut -d' ' -f1
ls -la --full-time $1 | cut -d' ' -f6,7 | cut -d'.' -f1
