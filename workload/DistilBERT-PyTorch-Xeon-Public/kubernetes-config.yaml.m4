#
# Apache v2 license
# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#
include(config.m4)

apiVersion: batch/v1
kind: Job
metadata:
  name: distilbert-pytorch-xeon-public
spec:
  template:
    spec:
      containers:
      - name: distilbert-pytorch-xeon-public
        image: IMAGENAME(defn(`K_DOCKER_IMAGE'))
        imagePullPolicy: IMAGEPOLICY(Always)
        volumeMounts:
        - mountPath: /dev/shm
          name: dshm
        env:
        - name: MODE
          value: "defn(`K_MODE')"
        - name: TOPOLOGY
          value: "defn(`K_TOPOLOGY')"
        - name: PRECISION
          value: "defn(`K_PRECISION')"
        - name: FUNCTION
          value: "defn(`K_FUNCTION')"
        - name: DATA_TYPE
          value: "defn(`K_DATA_TYPE')"
        - name: STEPS
          value: "defn(`K_STEPS')"
        - name: BATCH_SIZE
          value: "defn(`K_BATCH_SIZE')"
        - name: CORES_PER_INSTANCE
          value: "defn(`K_CORES_PER_INSTANCE')"
        - name: INSTANCE_NUMBER
          value: "defn(`K_INSTANCE_NUMBER')"
        - name: ONEDNN_VERBOSE
          value: "defn(`K_ONEDNN_VERBOSE')"
        - name: ENABLE_PROFILING
          value: "defn(`K_ENABLE_PROFILING')"
        - name: MAX_SEQ_LENGTH
          value: "defn(`K_MAX_SEQ_LENGTH')"
        - name: WARMUP_STEPS
          value: "defn(`K_WARMUP_STEPS')"
        - name: WEIGHT_SHARING
          value: "defn(`K_WEIGHT_SHARING')"
        - name: CUSTOMER_ENV
          value: "defn(`K_CUSTOMER_ENV')"
      NODEAFFINITY(preferred,HAS-SETUP-BKC-AI,"yes")
      volumes:
      - name: dshm
        emptyDir:
          medium: Memory
          sizeLimit: 4Gi
      restartPolicy: Never

