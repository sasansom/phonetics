Process a TextGrid into a CSV file:

```
src/textgrid2csv --column work=Od. --column book_n=9 "textgrid/02.03. Band 3 The Cyclops and Odysseus.TextGrid" > "textgrid/02.03. Band 3 The Cyclops and Odysseus.csv"
```

The CSV file will have `t_begin` and `t_end` columns
containing timestamps from the TextGrid.

Join the TextGrid CSV with a [SEDES](https://github.com/sasansom/sedes) CSV:

```
Rscript src/join-corpus.r "textgrid/02.03. Band 3 The Cyclops and Odysseus.csv" ../sedes/corpus/odyssey.csv > joined.csv
```

Make a graph of the joined CSV:

```
Rscript src/graph.r joined.csv "02.03. Band 3 The Cyclops and Odysseus-duration.png"
```
