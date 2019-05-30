workflow "Deploy on push to master" {
  on = "push"
  resolves = [
    "Branch Filter",
    "Configure Kube Credentials",
    "Deploy to EKS",
  ]
}

action "Branch Filter" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Configure Kube Credentials" {
  needs = ["Branch Filter"]
  uses = "actions/aws/cli@master"
  env = {
    AWS_DEFAULT_REGION = "us-west-2"
    CLUSTER_NAME = "mooplayground"
  }
  args = "eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_DEFAULT_REGION"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

action "Deploy to EKS" {
  needs = ["Configure Kube Credentials"]
  uses = "./.github/actions/eks-kubectl"
  runs = "sh -l -c"
  args = ["SHORT_REF=$(echo $GITHUB_SHA | head -c7) && cat $GITHUB_WORKSPACE/manifests/nginx.yaml | sed 's/TAG/'\"$SHORT_REF\"'/' | kubectl apply -f - "]
}
