git branch -M develop  
git add Readme.md 
git commit -m 'added readme'
git checkout -b feat/terraform-3-tier develop
git add .
it commit -m 'added terraform code'
git push --set-upstream origin feat/terraform-3-tier
git checkout develop    
git merge feat/terraform-3-tier
git push --set-upstream origin develop