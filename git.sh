#!/bin/bash
git add .
git commit -m "${1:-up}"
git push