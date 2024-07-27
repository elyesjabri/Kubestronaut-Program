# Kubernetes Cloud Native Security Associate (KCSA)

# Study Notes

###  1. Overview of Cloud Native Security

#### Infrastrucutre Security 

* Network access to API server (control plane):  All access to the kubernetes control plane is not allowed publicly on the internet and is controlled by network access control lists restricted to the set of IP neededd to administer the cluster

* Network access to nodes (nodes): Nodes should be configured to only accept connections (via network access control lists) from the control plane on the specified ports and accept connections for services in kubernetes of type NodePort and LoadBalancer. If possible,these nodes should not be exposed on the public internet entirely.

* Kubernetes access to cloud provider API: Each cloud provider needs to grant different set of permissions to the kubernetes control plane and nodes. It is best to provide the cluster with cloud provider access that follows the principle of least privillege for the reousources it needs to administer. The Kops documentation provices information about IAM policies and roles.

* Access to etcd: Access to etcd(the datastore of kubernetes) should be limited to the control plane only. Depending on your configuration, you should attempt to use etcd over TLS. More information can be found in the etcd documentations.

* etcd encryption: Whereever possible, It's a good practice to encrypt all storage at rest, and since etcd holds the state of the entire cluster (including Secrets), its disk should espacially be encrypted at rest.

#### The Four Cs of Cloud Native Security 

* Cloud 

* Cluster:  Cloud Layer / Network Layer / Infreastructure Layer

* Container:

    * Container vulnerability scanning and OS dependency security: As part of an image build step, you should scan your containers for known vulnerabilites.

    * Image signing and enforcement: Sign container images to maintain a system of trust for the content of your containers.

    * Disallowing privileged users: When constructing containers, consult your documentation for how to create users inside of the containers that have the least level of operating system privilege necessaey in order to carry out the goal of the container.

    * Using container runtime with stronger isolation: Select container runtime classes that provide stronger isolation

* Code: 
    
    * Access over TLS only: if your code needs to communicate by TCP, perform a TLS handshake with the client ahead of time. Whith the execption of a few cases, encrypt everything in transit. Going one step further, it's a good idea to encrypt network traffic between services. This can be done through a process known as mutal TLS authentification, or mTLS, which performs a two-sided verification of communication between two certificate holding services.

    * Limiting port ranges of communication: This recommendation may be a bit self-explanatory, but whereever possible, you should only expose the ports on your service that are absolutely essential for communication or metric gathering.

    * Third-party dependency security: It is a good practice to reguraly scan your application's third-party libraries for known security vulnerabilities. Each programming language has a tool for performing this check automatically.

    * Static Code Analysis: Most language provide a way for a snippet of code to be analyzed for any potentially unsafe coding practicies. Wherever possible, you should perform checks using automated tooling that can scan codebases for common security errors. 

    * Dyncamic Probing attacks: There are a few automated tools that you can run against your service to try some of the well-known service atacks. These include SQL injection, CSRF and XSS. One of the most popular dynamic analysis tools is the OWASP Zed Attack proxy tools

####  Cloud Provicer and infrastructure security

* Azure Cloud: 
    
    * Azure Security Center

    * Azure AD 

    * Build-in Registry

* Google Cloud Platform:

    * Security Dashbard

    * Out of the box CIS

    * Policy Complance

* EKS

#### Kubernetes Isolation:

* Namespaces: Give you the ability to begin the isolation process

* Network policies: Ingress and Egress rules

* Policy enforcement: Block or allow certain actions

* Role-based access control (RBAC): Authorization / permissions

#### Artifact and Image Repo Security:

* Acontainer image repo is where you store a caontainer image. a potential entry point for hackers.

#### Container Image Repos:

* Docker Hub

* Jfrog Artifactory 

#### Workload Security 

#### App Security:

* Scanning code

* checking code 

* Ensuring that code in the image is secure

#### Top five tips for app security:

1. Scan Code: 

    *  Security checks againts the code

2. Scan the container image:

    * Run tests to ensure the container image isn't riddled whith vulnerabilities

3. Have an automated security tool:

    * Kubescape,kube-bench

4. Use propoer RBAC:

    * Think least privilege from a permission perspective

5. Give containers what they need:

    * OWASP top 10 (securityContext)

###  2. Kubernetes Cluster Component Security

* Control Plane:

    * API server
    * etcd
    * Scheduler
    * Controller manager

* Worker Node:

    * kubelet

    * Container runtime

    * kube-proxy

    * Pods

    * CNI

    * Storage

#### API server and Controller Manager:

* API server ----> Kubernetes entry point

* Controller manager ----> desired state

#### Worker Node:

* Kubelet and Container Runtime:

  * kubelet --> kubernetes agent registers servers to the cluster
  * Container Runtime Interface (CRI)

* Kube-proxy : local network and manage pod connectivity 

    * Uses Iptables: like firewalls Rules (in large scale its slow and security is not garented)

* etcd: saves the cluster states... 
    * backups and snapshots

#### Container Networking and Client Security

* Container Network Interface (CNI)
    * NetworkPolicies, ingress and egress

#### Storage and Security

* Emcryption 
* backups
* test recovery 


###  3. Kubernetes Security Fundamentals

#### Pod Security Standards

* Privileged: Unrestriced policy, providing the widest possible level of permissions; allows for known privilege escalations

* Baseline: Minimally restrictive policy that prevetns known privilege escalations; allows the default (minimally specified) Pod configuration

* Restricted: Havilly restriced policy, following current pod hardening best practices

#### Pod Security Admissions

* enforce: policy violations will cause the pod to be rejected.

* audit: Policy violations will trigger the addition of an audit annotation to the event recorded in the audit log but are otherwise allowed.

* warn: Policy violations will trigger a user-facing warning but are otherwide allowed.

#### Authentication (think of login for example)

#### Authorization (think RBAC and permissions)

#### Isolation and Segregation

* Namespaces

* RBAC

### Policy Enforcement

* OPA

* Kyvenro

* Admission Controller


###  4. Kubernetes Threat Model

#### Kubernetes Trust Boundaries

* Internet: The externally facing, wider internet zone

* API server: The master component, usually exposed to cluster users, needed for interaction with kubectl

* Master Componenets: Internal components of the master node that work via callvacks and subscriptions to the API serer

* Master Data: The master data layer that stores the cluster state; example etcd

* Worker: The worker components that are required to add a node in the cluster and to run containers

* Container: The containers being orchastrated by the cluster

#### Kubernetes Data Flow

###  5. Platform Security


###  6. Compliance and Security Frameworks

#### Compliance Frameworks

* standards,protocols and auditing

* HIPAA,PHI and hight-trust certifications 

* Compliance is like a check-list of best practices:

    * CIS Benchmarks: list of best practices

    * National Vulnerability Database (NVD)

    * National institue of Standards and Technology (NIST) database

#### Threat Modeling Frameworks

* Identify security requierements

* Check security threats

* Understand potential vulns

#### Zero trust models

 * Relies on:
    * Authentication
    
    * Authorization

    * Continuous validation of access

#### Supply Chain Compliance

* Artifacts

* Metadata 

* Attestations

* Policies 




