sp = "Abutilon incanum"
sp = "Abies alba"
sp = "Abies albas"
sp = "Abutilon malacum"

usda_native <- function(sp){
  d <- read.table("data/USDA_Plants.txt", header = TRUE, sep = ",")
  if(length(which(d$Scientific.Name == sp)) = 0){
    print("Species not found")
  } else {
    status <- d[which(d$Scientific.Name == sp), "Native.Status"]
    status2 <- strsplit(as.character(status), ",")[[1]]
    status2 <- gsub(" ", "", status2)
    status2 <- gsub(")", "", status2, fixed = TRUE)
    status3 <- unlist(strsplit(status2, "(", fixed = TRUE))
    Out <- as.data.frame(matrix(data = status3, nrow = length(status3)/2, ncol = 2, byrow = TRUE))
    colnames(Out) <- c("Area", "Status")
    Out
  }
}
