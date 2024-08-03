docker run --rm `
  --volume="$(Get-Location):/srv/jekyll:Z" `
  --publish 4000:4000 `
  jekyll/jekyll `
  jekyll serve