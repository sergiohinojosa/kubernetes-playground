# Kubernetes Cluster Set-up


## Prerequisite
The only prerequisite for Kubernetes-Playground is that you get an Ubuntu machine and that it has an internet connection. This can be a VirtualMachine running in your datacenter, on your laptop or in a cloud provider such as Microsoft Azure, Amazon Web Services, Google Cloud among others. 
The tested distribution  **Ubuntu Server 20.04 LTS**

#### ☁️ Get a cloud VM
Don't have a VM or a Cloud Account? Don't worry, here you can sign for a free tier in:
  - [Amazon Web Services](https://aws.amazon.com/free/) 
  - [Microsoft Azure](https://azure.microsoft.com/en-us/free/)
  - [Google Cloud](https://cloud.google.com/free)


#### 💻 Get a local VM
Want to try it locally? Not a problem. Check out [multipass](https://multipass.run/)! a great way for spinning instant Ubuntu VMs in Windows, Mac or Linux computers.


### 📏 Sizing 
For the 😎 ultimate experience we recommend a `t3.2xlarge` with 8 Cores, 32 Gigs of RAM and at least 20 Gigs of diskspace.

### ☎️ Open ports
If you define security rules in the Cloud provider or on your datacenter, your instance only needs to have the following ports accessible: 
- 22  / SSH 
- 80  / HTTP
- 443 / HTTPS


### Other considerations
The functions.sh was developed under Ubuntu but this does not mean it won't work for other Operative systems such as CentOS, Fedora, openSuse, etc... If you are willing to try it out, we would love to hear the results. Just bear in mind that the installation of Microk8s depends on [Snapcraft package manager](https://snapcraft.io/). Your chances are quite high since Microk8s is available in 42 Linux flavours.


# Installation
## Manual Installation (get started in 1 - 2 - 3)

### 1. Log in into  your Ubuntu image

### 2. Download `k8splay-install.sh`, edit it and make it executable

Now let's download the `k8splay-install.sh` file and make it executable.

```bash
curl -O https://raw.githubusercontent.com/sergiohinojosa/kubernetes-playground/master/cluster-setup/k8splay-install.sh
chmod +x k8splay-install.sh
```
> You dont need to clone all the repo, only download the **k8splay-install.sh** file. When executing it, it'll take care of the rest and load the resources from github.

Before starting the installation, you can customize it and control what you want to install.

#### 3. Execute the file with sudo rights.
```bash
sudo bash -c './k8splay-install.sh &'
```
And that was it! Yes that easy!  Now if you notice is that there is an & in the command. This command will run installation in a bash shell as sudo, will prompt you for the password and will send the job to the background. You will not see any output since stdout and stderr are piped to a logfile which is located by default in **/tmp/k8splay-install.log** 

Why run it in the background and where is the output of the program you say? Well, k8splay is actually optimized to be executed for non-interactive shells at the initialization of an instance. This is done programmatically passing the script as [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) while creating dynatrace environments and spinning multiple instances for each student. This is achieved with the [Dynatrace Rest Tenant Automation](https://github.com/sergiohinojosa/Dynatrace-REST-Tenant-Automation) program. Yes, we love ❤️ automation 🤖 and the customization, creation and configuration of environments and instances is done programmatically.

#### 🔍 Inspect the script at runtime
For inspecting the installation on realtime type:
```bash
less +F /tmp/kiab-install.log
```
This will open the installation log and read from the input stream. To exit just type `CTRL + C` and then `quit`.


## Other installation options
### Spin your preconfigured K8s-Play machine with userdata  (manually in aws)
1. Log in to AWS
2. Click on "Launch instance"
3. Select "Ubuntu Server 20.04 LTS (HVM) "
4. Choose your Instance Type "t3.xlarge" or 2xlarge recommended.
5. Select "Next - configure instance details"
6. In Configure Instance details - Advanced options (below) copy the keptn-in-a-box.sh file. (as string or drop it, doesn't matter). Remember to edit your file if you want to customize your box.
7. Review it and launch your instance.

### Spin your preconfigured K8s-Play machine with userdata (automated)
- Description to be added. Please see the [Dynatrace Rest Tenant Automation project](https://github.com/sergiohinojosa/Dynatrace-REST-Tenant-Automation) for reference. The RTA project can spin as many instances as you want by providing a simple CSV file. It will also create and configure Dynatrace environments for each CSV entry, 😍 perfect for delivering workshops 👨‍💻. If you are interested in a workshop get in contact with us. 




## Logic & architecture of the scripting
The set-up of the cluster basically consists of two bash functions:

1. [k8splay-install.sh](k8splay-install.sh)
2. [functions.sh](functions.sh)

The bash files are scripted in a modular fashion allowing you with control flags to enable or disable the modules that you want to install in your box. This allows you to have a very slim k8s cluster running with the bare minimal resources or to have a full blown cluster with pretty much all the desired features and frameworks for your let's say CI/CD pipelines and performance testings.


## [k8splay-install.sh](k8splay-install.sh)

This file is the main installation process. In here you control exactly what you want to install and the version or release to install. The different modules are packed in installationBundles (e.g. which modules you want to install but this can be also enabled and disabled manually e.g. `git_deploy=true`). Custom information such as the Dynatrace credentials, the username and password, release branch.

[k8splay-install.sh](k8splay-install.sh) will download the release specified of the [functions.sh](functions.sh), load it in the shell and then kick-off the installation on the `doInstallation` function. 


## [functions.sh](functions.sh)

The [functions.sh](functions.sh) file is where the logic of the installation is kept, and the different modules and its versions are managed in atomic and independent functions. At the end of the file you'll find the function `doInstallation()` which is the one that defines the order of installation.


#### On a high level Kubernetes architecture this is how the setup of the Microkubernetes machine is setted up:
![#](../doc/img/micro-diagram-with-keptn.png)



## Contributing
If you have any ideas for improvements or want to contribute that's great. Create a pull request or file an issue.

## Author 
sergio.hinojosa@dynatrace.com