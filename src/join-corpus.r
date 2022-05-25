# Joins a TextGrid CSV file (as produced by textgrid2csv) with a corpus CSV
# file (as produced by SEDES tei2csv) on the "work", "book_n", "line_n", and
# "word_n" columns, and adds "syllable_metrical_shape" and "syllable_sedes"
# columns.
#
# Usage:
#   Rscript join-corpus.r TEXTGRID.csv CORPUS.csv

(function() {
	args <- commandArgs(trailingOnly = TRUE)
	if (length(args) != 2) {
		stop("usage: join-corpus.r TEXTGRID.csv CORPUS.csv")
	}
	textgrid_csv_path <<- args[[1]]
	corpus_csv_path <<- args[[2]]
})()

library("tidyverse")

textgrid <- read_csv(textgrid_csv_path)
corpus <- read_csv(corpus_csv_path)

joined <- left_join(textgrid %>% mutate(word = NULL), corpus, by = c("work", "book_n", "line_n", "word_n")) %>%
	mutate(syllable_metrical_shape = substr(metrical_shape, syllable_n, syllable_n)) %>%
	# For each word, add up the metrical shapes markers incrementally to
	# get the sedes of each syllable.
	group_by(work, book_n, line_n, word_n, sedes) %>%
		mutate(syllable_sedes = sedes + Reduce(
			function(sedes, syl) {
				# Count up the sedes for each syllable, adding
				# 0.5 for a short and 1.0 for a long.
				sedes + c("⏑"=0.5, "–"=1.0)[[syl]]
			},
			# Cut off the last metrical shape marker, because
			# adding that takes us to the beginning of the next
			# word.
			syllable_metrical_shape[1:length(syllable_metrical_shape)-1],
			0,
			accumulate = TRUE
		)) %>%
	ungroup()

cat(format_csv(joined))
