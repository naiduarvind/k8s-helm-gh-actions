workflow "Deploy on push to master" {
  on = "push"
  resolves = [
    "filter",
    "kube",
  ]
}

action "filter" {
  uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd"
  args = "branch master"
}

action "kube" {
  uses = "docker://registry.hub.docker.com/lachlanevenson/k8s-kubectl:v1.13.3"
  runs = "kubectl apply -f nginx-sample/"
  needs = ["filter"]
  secrets = ["KUBE_SERVER", "KUBE_TOKEN", "KUBE_CA"]
}
