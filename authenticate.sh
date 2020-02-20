#!/bin/bash
export GOOGLE_CLOUD_KEYFILE_JSON="$PWD/credentials/$(ls ./credentials | head -n 1)"
