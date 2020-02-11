library(tidyverse)
library(tidyr)
library(dplyr, warn.conflicts = F)
bic.metadata <- read_csv("EnglishMS414.csv") 
# this is a simplified csv file containing 
# all of the names of people (and dates of submissions) associated with each manuscript item for the BOW IN THE CLOUD, 
# based on the ms archive ENG 414-415 at the John Rylands Library
bic.metadata

# creating a vector that lists all distinct items under the column heading 'destination'
origins <- bic.metadata %>%
  distinct(destination) %>%
  rename(label = destination)
origins

# creating a vector that lists all distinct items under the column heading 'creator'
creators <- bic.metadata %>%
  distinct(creator) %>%
  rename(label = creator)
creators

# create a single dataframe with a column that joins previous two vectors into a nodes (entities) list
nodes <- full_join(origins, creators, by = "label")
nodes

# changes to id numbers (instead of names-as-strings)
nodes <- nodes %>% rowid_to_column("id")
nodes

per.submission <- bic.metadata %>%
  group_by(destination, creator) %>%
  summarise(weight = n()) %>% 
  ungroup()

per.submission

edges <- per.submission %>%
  left_join(nodes, by = c("destination" = "label")) %>%
  rename(from = id)

edges <- edges %>%
  left_join(nodes, by = c("creator" = "label")) %>%
  rename(to = id)

edges <- select(edges, from, to, weight)
edges

library(network)
routes_network <- network(edges, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE)
class(routes_network)

routes_network
plot(routes_network, vertex.cex = 5)

detach(package:network)
rm(routes_network)
library(igraph)

routes_igraph <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)

routes_igraph
plot(routes_igraph, edge.arrow.size = 0.5)
plot(routes_igraph, layout = layout_with_graphopt, edge.arrow.size = 0.5)

library(tidygraph)
library(ggplot2)
library(udunits2)
library(ggraph)
# ggraph is in development; you need to download directly from git by typing in the console: "devtools::install_github('thomasp85/ggraph')"
# if this does not work you might also need to install the 'udunits2' package

routes_tidy <- tbl_graph(nodes = nodes, edges = edges, directed = TRUE)
routes_igraph_tidy <- as_tbl_graph(routes_igraph)
class(routes_tidy)

routes_tidy %>% 
  activate(edges) %>% 
  arrange(desc(weight))

ggraph(routes_tidy) + geom_edge_link() + geom_node_point() + theme_graph()

ggraph(routes_tidy, layout = "graphopt") + 
  geom_node_point() +
  geom_edge_link(aes(width = weight), alpha = 1.0) + 
  scale_edge_width(range = c(0.5, 12)) +
  geom_node_text(aes(label = label), repel = TRUE) +
  labs(edge_width = "Material sent") +
  theme_graph()

library(visNetwork)
library(networkD3)

visNetwork(nodes, edges)
edges <- mutate(edges, width = weight/10 + 1)

visNetwork(nodes, edges) %>% 
  visIgraphLayout(layout = "layout_with_fr") %>% 
  visEdges(arrows = "middle")

nodes_d3 <- mutate(nodes, id = id - 1)
edges_d3 <- mutate(edges, from = from - 1, to = to - 1)

forceNetwork(Links = edges_d3, Nodes = nodes_d3, Source = "from", Target = "to", 
             NodeID = "label", Group = "id", Value = "weight", 
             opacity = 1, fontSize = 16, zoom = TRUE)
