# Packer - azure arm - Prontus Image gallery

Create a master Ubuntu 18.04 image with a fresh prontus CMS installation and configuration using packer. First create a new Ubuntu 
VM based on the latest image on the azure market place, updates the OS and installs the provided script, then deprovisions the VM and
generalizes it. This VM disk is made into a managed image resource, which then in turns gets exported into an existing shared image 
gallery with an image definition (template with the same OS version, location, etc.). The image definition can receive an update to
a version or a completely new one.

The Packer config requires the decompressed installation files for Prontus inside the root directory, these are uploaded to the 
temporary VM to the /tmp dir. Some minor modifications were made to the provided sh script installer to be able to target Ubuntu 
18.04.
