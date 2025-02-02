library(DiagrammeR)

DiagrammeR::grViz("
digraph {

graph [layout = dot, rankdir = TB]

# define the global styles of the nodes. We can override these in box if we wish
node [shape = rectangle, style = filled, fillcolor = Linen, fontsize = 24]

edge [fontsize = 12]  # Set the font size for edge labels

data1 [label = 'Mitochondrial Sequences (n=4338)', shape = folder, fillcolor = Beige]
statistical [label = 'Execute SigClust with \n Chosen Parameters']
results [label= 'Construct Distance Matrix \n for Each Cluster']
five [label= 'Find Cluster Centers']
six [label= 'Analyse Cluster Contents \n and Centers']
seven [label = 'Best Performing Cluster Centers \n are Representatives for PBR']

data1 -> statistical -> results -> five -> six -> seven
six -> statistical [xlabel = '       Repeat for Different \n      Parameter Values', constraint = false, style = 'dashed', fontsize = 24]

}
")

class(graph)
install.packages("vtree", dependencies = TRUE)
library(vtree)

bioComp <- 88*0.1667
Hpc <- 74.8*0.0556
Mini <- 81.5*0.1111
Exam <- 52*0.2778
proj <- 45*0.3889

bioComp+Hpc+Mini+Exam+proj
