workflow "Deploy on push to master" {
  on = "push"
  resolves = [
    "filter",
    "kube",
   ]
}

action "filter" {
  uses = "actions/bin/filter@707718ee26483624de00bd146e073d915139a3d8"
  args = "branch master"
}

action "kube" {
  uses = "docker://registry.hub.docker.com/lachlanevenson/k8s-kubectl:v1.13.3"
  runs = "kubectl apply -f nginx-sample/"
  needs = ["filter"]
  secrets = ["KUBE_SERVER", "KUBE_TOKEN", "KUBE_CA"]
}
