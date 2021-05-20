#!/usr/bin/env Rscript

convert_ids_to_entrez <- function(ids, gene_keytype){
  possible_ids <- columns(org.Hs.eg.db)
  if(! gene_keytype %in% possible_ids) 
    stop(paste(c("gene keytype must be one of the following:", possible_ids), collapse=" "))
  ids <- tryCatch(
    ids <- mapIds(org.Hs.eg.db, keys=ids, column="ENTREZID", keytype=gene_keytype),
    error=function(cond){
      ids <- NULL
    }
  )
  return(ids[!is.na(ids)])
}

multienricher <- function(funsys, cluster_genes_list, task_size, workers){
  enrichments_ORA <- list()
  for(funsys in all_funsys) {
    ENRICH_DATA <- clusterProfiler:::get_GO_data(org.Hs.eg.db::org.Hs.eg.db, funsys, "ENTREZID")
    enrf <- clusterProfiler::enrichGO
    patter_to_remove <- "GO_DATA *<-"
    ltorem <- grep(patter_to_remove, body(enrf))
    body(enrf)[[ltorem]] <- substitute(GO_DATA <- ENRICH_DATA)

    enriched_cats <- ExpHunterSuite:::parallel_list(cluster_genes_list, function(cl_genes){
       enr <- enrf(gene = cl_genes,
                   OrgDb         = org.Hs.eg.db::org.Hs.eg.db,
                   pAdjustMethod = "BH", ont = funsys,
                   pvalueCutoff  = 0.05, qvalueCutoff = 0.02)
       return(enr)
      }, 
      workers= workers, task_size = task_size
    )
    enrichments_ORA[[funsys]] <- enriched_cats
  }
  return(enrichments_ORA)
}


write_fun_enrichments <- function(enrichments_ORA, output_path, all_funsys){
  for(funsys in all_funsys) {
    enriched_cats <- enrichments_ORA[[funsys]]
    enriched_cats_dfs <- lapply(enriched_cats, data.frame)
    enriched_cats_bound <- data.table::rbindlist(enriched_cats_dfs, use.names= TRUE, idcol= "Cluster_ID" )
    utils::write.table(enriched_cats_bound, 
                       file=file.path(output_path, paste0("enrichment_",funsys,".csv")),
                       quote=FALSE, col.names=TRUE, row.names = FALSE, sep="\t")
  }
}

option_list <- list(
  optparse::make_option(c("-i", "--input_file"), type="character", default=NULL,
                        help="2 columns - cluster and comma separated gene ids"),
  optparse::make_option(c("-w", "--workers"), type="integer", default=1,
                        help="number of processes for parallel execution"),
  optparse::make_option(c("-t", "--task_size"), type="integer", default=1,
                        help="number of clusters per task"),
  optparse::make_option(c("-k", "--gene_keytype"), type="character", default="ENTREZID",
                        help="What identifier is being used for the genes in the clusters?"),
    optparse::make_option(c("-o", "--output_file"), type="character", default="results",
                        help="Define the output path.")
)
opt <- optparse::parse_args(optparse::OptionParser(option_list=option_list))

##################################### INITIALIZE ##
library(optparse)
library(clusterProfiler)
library(org.Hs.eg.db)
library(AnnotationDbi)
dir.create(opt$output_file)
output_path <- normalizePath(opt$output_file)
#################################### MAIN ##
cluster_genes <- read.table(opt$input_file, header=TRUE)
cluster_genes_list <- strsplit(cluster_genes[,2], ",")
if(opt$gene_keytype != "ENTREZID") {
  cluster_genes_list <- sapply(cluster_genes_list, function(x){
                                    convert_ids_to_entrez(ids=x, 
                                                          gene_keytype=opt$gene_keytype)}) 
}
names(cluster_genes_list) <- cluster_genes[,1]

all_funsys <- c("MF", "CC", "BP")
enrichments_ORA <- multienricher(all_funsys, cluster_genes_list, opt$task_size, opt$workers)
write_fun_enrichments(enrichments_ORA, output_path, all_funsys)


# organisms_table <- ExpHunterSuite::get_organism_table()
# current_organism_info <- subset(organisms_table, rownames(organisms_table) == "Human")
# system.time(
# enriched_cats4 <- ExpHunterSuite::multienricher(cluster_genes_list, organism_info = current_organism_info
# , ontology="m", pvalueCutoff = 0.05, pAdjustMethod = "BH")
# )
