#!/bin/sh
terraform graph | dot -Tsvg > graph.svg
