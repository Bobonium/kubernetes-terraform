# Data Module

This module should be used in all kubernetes modules to ensure consistent naming & labeling of resources

outputs:
 - namespaceUniqueName
   - to be used for namespace-wide resources
 - clusterUniqueName
   - to be used for cluster-wide resources
 - labels to be used with all resources
   - includes [recommended kubernetes labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels)
   - additional labels are supplied through ```${var.additionalLabels}```
     - ```${var.additionalLabels}``` key-value pair will be ignored if the same key exists in the recommended kubernetes labels
 - matchLabels
 - annotations for
   - ingress
   - service
   - pod
   - namespace
