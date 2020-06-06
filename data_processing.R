read_in <- fread("/Users/jahanrahman/Desktop/development/testset.tsv", stringsAsFactors = F, header = TRUE, quote="")
read_in$Source <- gsub('"', '#', read_in$Source)
read_in$Source <- gsub('##', '"', read_in$Source)

read_in <- select(read_in, Title, Author, Medium)

save.image("/Users/jahanrahman/Desktop/development/processed.RData")

