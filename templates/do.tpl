              { 
                    "schemaVersion": "1.15.0",
                    "class": "Device",
                    "async": true,
                    "label": "my BIG-IP declaration for declarative onboarding",
                    "Common": {
                        "class": "Tenant",
                        "hostname": "{{ host_name }}",
                        "admin": {
                            "class": "User",
                            "userType": "regular",
                            "password": "{{ admin_pass }}",
                            "shell": "bash"
                        },
                        "myDns": {
                            "class": "DNS",
                            "nameServers": [
                                "8.8.8.8"
                            ]
                        },
                        "myNtp": {
                            "class": "NTP",
                            "servers": [
                                "0.pool.ntp.org"
                            ],
                            "timezone": "UTC"
                        },
                        "myProvisioning": {
                            "class": "Provision",
                            "ltm": "nominal"
                        },
                        "external": {
                            "class": "VLAN",
                            "tag": 1001,
                            "mtu": 1500,
                            "interfaces": [
                                {
                                    "name": 1.1,
                                    "tagged": false
                                }
                            ]
                        },
                        "external-self": {
                            "class": "SelfIp",
                            "address": "{{ external_ip }}",
                            "vlan": "external",
                            "allowService": "none",
                            "trafficGroup": "traffic-group-local-only"
                        },
                        "internal": {
                            "class": "VLAN",
                            "tag": 1002,
                            "mtu": 1500,
                            "interfaces": [
                                {
                                    "name": 1.2,
                                    "tagged": false
                                }
                            ]
                        },
                        "internal-self": {
                            "class": "SelfIp",
                            "address": "{{ internal_ip }}",
                            "vlan": "internal",
                            "allowService": "default",
                            "trafficGroup": "traffic-group-local-only"
                        },
                        "dbvars": {
                            "class": "DbVariables",
                            "provision.extramb": 500,
                            "restjavad.useextramb": true
                        }
                    }
                }