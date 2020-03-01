#!/usr/bin/env python
import os
import json
import sys
import subprocess

def iter_tfstate():
    wd = os.getcwd()
    f = subprocess.check_output(["terraform", "state", "pull"])
    tfstate_dict = json.loads(f)
    try:
        nodes = {}
        for i in tfstate_dict['resources']:
            if 'module.elastic-ec2' in i.get("module", "default"):
                for j in i['instances']:
                    nodes[j['attributes']['tags']['Name']] = j['attributes']['public_ip']
        return nodes
    except Exception as e:
        print("Unable to get node IPs")
        sys.exit(1)

def create_inventory(nodes):
    wd = os.getcwd()
    try:
        inventory = ""
        inventory = inventory + "[elastic]\n"
        for hostname in sorted(nodes):
            inventory = inventory + hostname + " " + "ansible_host=" + nodes[hostname] + " ansible_user=centos\n"
        wd = os.getcwd()
        f = open(wd + "/ansible_inventory", 'w')
        f.write(inventory)
    except Exception as e:
        print("Unable to create inventory")
        sys.exit(1)

def main():
    print("Generating Ansible Inventory .....")
    n = iter_tfstate()
    create_inventory(n)

if __name__== "__main__":
    main()
