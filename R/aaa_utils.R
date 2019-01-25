sub_space = function(tab) {
  tab = gsub(" +", " ", tab)
  tab = gsub(" (\n|\t)", "\\1", tab)
  tab = gsub("(\n|\t) ", "\\1", tab)
  tab = gsub("\n+", "\n", tab)
  tab = gsub("\t+", "\t", tab)
  tab = gsub("\t\n", "\n", tab)
  tab = gsub("\n\t", "\n", tab)
  tab = gsub("\t", "\n", tab)
  tab = gsub("\n+", "\n", tab)
  tab
}

sub_weird_space = function(x) {
  gsub("\xc2\xa0", " ", x)
}

sub_ascii = function(x) {
  x = gsub("\U201C", '"', x)
  x = gsub("\U201D", '"', x)
  x = gsub("\U2019|\U2018|\U201B", "'", x)
  x = gsub("\U201A", ',', x)
  x
}
