# Makes a graph from a joined TextGrid CSV file and a corpus CSV file.
#
# Usage:
#   Rscript graph.r JOINED.csv OUTPUT.png

(function() {
	args <- commandArgs(trailingOnly = TRUE)
	if (length(args) != 2) {
		stop("usage: graph.r JOINED.csv OUTPUT.png")
	}
	joined_csv_path <<- args[[1]]
	output_path <<- args[[2]]
})()

library("tidyverse")

joined <- read_csv(joined_csv_path)

p <- ggplot(joined) +
#	geom_density(aes(
#		t_end - t_begin,
#		fill = syllable_metrical_shape,
#		after_stat(count)
#	), alpha = 0.6, position = "identity", adjust = 0.5) +
# 	geom_boxplot(aes(
#		syllable_metrical_shape,
#		t_end - t_begin,
#		color = syllable_metrical_shape,
#	)) + coord_flip() +
	geom_point(aes(
		syllable_metrical_shape,
		t_end - t_begin,
		color = syllable_metrical_shape,
	), alpha = 0.75) + coord_flip() +
	scale_y_continuous(limits = c(0, NA)) +
	facet_grid(rows = vars(syllable_sedes))

ggsave(output_path, p, width = 6, height = 10, dpi = 192)
