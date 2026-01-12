ibrary(readxl) 
data = read_excel("File project.xlsx", sheet = 2) 
str(data)

# 1. Pilih variabel untuk clustering
data_cluster <- data 

# 2. Hitung jarak Euclidean
data_dist <- dist(data_cluster[-1], method = "euclidean")  # kolom Provinsi dihapus
rownames(data_cluster) <- data_cluster$Provinsi

# 3. Hierarchical clustering (average linkage)
clust <- hclust(data_dist, method = "average")

# 4. Potong dendrogram menjadi 3 cluster
data_cluster$Cluster3 <- cutree(clust, k = 3)
table(data_cluster$Cluster3)

# 5. Visualisasi dendrogram dengan 3 cluster
plot(clust, cex = 0.7, hang = -1)
rect.hclust(clust, k = 3, border = 2:4)

# 6. Visualisasi cluster (PCA)
fviz_cluster(list(data = data_cluster[-1], cluster = data_cluster$Cluster3),
             ellipse.type = "convex",
             palette = "jco",
             ggtheme = theme_minimal())
print(data_cluster, n=34)

library(dplyr)

data_cluster %>%
  group_by(Cluster3) %>%
  summarise(
    mean_FAC1 = mean(FAC1_3),
    mean_FAC2 = mean(FAC2_3),
    mean_FAC3 = mean(FAC3_3),
    n = n()
  )





# ===================================
# NON-HIRARKI: K-MEANS CLUSTERING
# ===================================

library(tidyverse)
library(factoextra)

# 1. Pilih variabel utama (3 dimensi kebahagiaan)
data_km <- data 
head(data_km)
summary(data_km)

# ------------------------------
# 2. CEK OUTLIER (Boxplot)
# ------------------------------
data_km_long <- gather(data_km[-1], key = "Variabel", value = "Nilai")

ggplot(data_km_long, aes(x = Variabel, y = Nilai, fill = Variabel)) +
  geom_boxplot() +
  labs(x = "Variabel", y = "Nilai") +
  theme_classic()

# ------------------------------
# 3. (Opsional) Standarisasi
# Tidak dilakukan karena skala sudah seragam
# ------------------------------
data_km_s <- data_km[-1]   # gunakan data asli tanpa standar

# ------------------------------
# 4. Cek Jumlah Klaster Optimal
# ------------------------------

## Elbow Method
set.seed(100)
fviz_nbclust(data_km_s, kmeans, method = "wss") +
  labs(title = "Elbow Method untuk Menentukan Jumlah Klaster")

## Silhouette Method
fviz_nbclust(data_km_s, kmeans, method = "silhouette") +
  labs(title = "Silhouette Method")

# (Biasanya 3 cluster masuk akal berdasarkan dimensi kebahagiaan)

# ------------------------------
# 5. FINAL K-MEANS (3 CLUSTERS)
# ------------------------------
set.seed(100)
clust_km <- kmeans(data_km_s, centers = 3, nstart = 25)

# Lihat centroid (nilai rata-rata tiap klaster)
clust_km$centers

# Tambahkan label klaster ke data asli
data_km$Cluster3 <- clust_km$cluster
View(data_km)

# ------------------------------
# 6. VISUALISASI K-MEANS
# ------------------------------
fviz_cluster(clust_km,
             data = data_km_s,
             palette = "jco",
             repel = TRUE,
             ggtheme = theme_minimal()) +
  labs(title = "Visualisasi K-Means (3 Cluster)")








# Library
library(readxl)
library(tidyverse)
library(factoextra)
library(clValid)

# HIERARKI METHOD ---------------------------------------------------------
# Data
data1 = read_excel("C:/Users/LENOVO/Downloads/File project.xlsx", sheet = 2) 

# Bisa dicek juga pakai boxplot
data1_long <- gather(data1[-1], key = "Variabel", value = "Nilai")
head(data1_long)

ggplot(data1_long, aes(x = Variabel, y = Nilai, fill = Variabel)) +
  geom_boxplot() +
  labs(x = "Variabel", y = "Nilai") +
  theme_classic()

# Menggunakan data asli (tanpa scaling)
data1_s <- data1[-1]

# Menghitung distance (Proximity Matrix)
data1_s_dist <- dist(x = data1_s, method = "euclidean")
data1_s_dist
fviz_dist(data1_s_dist, gradient = list(low="tomato",
                                        mid="white", high="green"))

### CLUSTERING
clust1 <- hclust(d = data1_s_dist, method = "average")

## Label Klaster
data1_s_clust = cbind(data1[1], data1_s)
data1_s_clust["Clust5"] = cutree(clust1, k = 5)
data1_s_clust["Clust4"] = cutree(clust1, k = 4)
data1_s_clust["Clust3"] = cutree(clust1, k = 3)
data1_s_clust["Clust2"] = cutree(clust1, k = 2)
View(data1_s_clust)

table(data1_s_clust$Clust5)
table(data1_s_clust$Clust4)
table(data1_s_clust$Clust3)
table(data1_s_clust$Clust2)

### VISUALISASI
data1_s = data.frame(data1_s)
rownames(data1_s) = data1[[1]]

# Distance dan clustering
data1_s_dist <- dist(data1_s, method = "euclidean")
clust1 <- hclust(data1_s_dist, method = "average")

## 5 Cluster
plot(clust1, cex = 0.7, hang = -2)
rect.hclust(clust1, k = 5, border = 2:8)

fviz_dend(clust1, k = 5, k_colors = "jco", rect = TRUE,
          main = "Cluster Dendrogram Average Linkage")

fviz_cluster(list(data = data1_s, cluster = data1_s_clust$Clust5))
view(data1_s_clust$Clust5)

## 4 Cluster
plot(clust1, cex = 0.7, hang = -2)
rect.hclust(clust1, k = 4, border = 2:8)

fviz_dend(clust1, k = 4, k_colors = "jco", rect = TRUE,
          main = "Cluster Dendrogram Average Linkage")

fviz_cluster(list(data = data1_s, cluster = data1_s_clust$Clust4))

## 3 Cluster
plot(clust1, cex = 0.7, hang = -2)
rect.hclust(clust1, k = 3, border = 2:8)

fviz_dend(clust1, k = 3, k_colors = "jco", rect = TRUE,
          main = "Cluster Dendrogram Average Linkage")

fviz_cluster(list(data = data1_s, cluster = data1_s_clust$Clust3))

## 2 Cluster
plot(clust1, cex = 0.7, hang = -2)
rect.hclust(clust1, k = 2, border = 2:8)

fviz_dend(clust1, k = 2, k_colors = "jco", rect = TRUE,
          main = "Cluster Dendrogram Average Linkage")

fviz_cluster(list(data = data1_s, cluster = data1_s_clust$Clust2))


# Jumlah Klaster Optimal
rownames(data1_s) <- 1:nrow(data1_s)

internal <- clValid(data1_s, nClust = 2:5,
                    clMethods = "hierarchical",
                    validation = "internal",
                    metric = "euclidean",
                    method = "average")
summary(internal)
