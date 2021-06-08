#!/usr/bin/env ruby

########################################################
## initialize
########################################################
require 'optparse'

########################################################
##functions
########################################################


def load_patient_genes(patient2gene)
	patient_genes = {}
	File.open(patient2gene).each do |line|
		line = line.chomp.split("\t")
		patient_id, genes = line
		patient_genes[patient_id] = genes.split(",")		
	end
	return patient_genes
end


def load_clusters(patients2clusters)
	clusters_patients = {}
	File.open(patients2clusters).each do |line|
		line = line.chomp.split("\t")
		patient_id, cluster = line
		clusters_patients[cluster] = [] if clusters_patients[cluster].nil?
		clusters_patients[cluster] << patient_id
	end
	patient_clusters = {} # filtering clusters with only one patient
	clusters_patients.each do |cluster, patients|
		next if patients.length == 1
		patients.each do |patient|
			patient_clusters[patient] = cluster
		end
	end
	return patient_clusters
end


def get_cluster_genes(patient_genes, patient_clusters)
	cluster_genes = {}
	patient_genes.each do |patient_id, genes|
		cluster = patient_clusters[patient_id]
		next if cluster.nil?
		cluster_genes[cluster] = [] if cluster_genes[cluster].nil?
		cluster_genes[cluster] << genes 
	end
	return cluster_genes
end

def parse_and_filter(clusters_genes, min_patients)
	parsed_cluster_genes = {}
	puts ["cluster", "geneid", "patient_count"].join("\t")
	clusters_genes.each do |cluster, genes|
		cluster_genes = Hash.new(0)
		genes.flatten!
		genes.each do |gene|
			cluster_genes[gene] += 1
		end
		cluster_genes = cluster_genes.select{|gene, patients| patients >= min_patients}
		cluster_genes.each do |gene, patients|
			puts [cluster, gene, patients].join("\t")
		end
		parsed_cluster_genes[cluster] = cluster_genes.keys unless cluster_genes.empty?
	end
	return parsed_cluster_genes
end

def write_output(cluster_genes, output_file)
	File.open(output_file, 'w') do |outfile|
		cluster_genes.each do |cluster, genes|
			outfile.puts "#{cluster}\t#{genes.join(",")}"
		end
	end
end

########################################################
## options
########################################################
options = {}
OptionParser.new do |opts|

  options[:patients2clusters] = nil
  opts.on("-c file", "--patient_clusters file", "A tabular file with patient ID in first column and cluster ID in the second") do |data|
    options[:patients2clusters] = data
  end

  options[:patient2gene] = nil
  opts.on("-g file", "--patients_gene file", "Input tabular file with patients ID as first column and comma separated genes as second column") do |data|
    options[:patient2gene] = data
  end

  options[:min_patients] = 1
  opts.on("-m INT", "--min_patients INT", "Minimun number of patients in cluster supporting a gene. Default = #{options[:min_patientsn]}.") do |int|
    options[:min_patients] = int.to_i
  end

  options[:output_file] = nil
  opts.on("-o", "--output_file PATH", "Output file") do |data|
    options[:output_file] = data
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
 
end.parse!

########################################################
## main
########################################################
patient_genes = load_patient_genes(options[:patient2gene])
patient_clusters = load_clusters(options[:patients2clusters])
cluster_genes = get_cluster_genes(patient_genes, patient_clusters)
cluster_genes2 = parse_and_filter(cluster_genes, options[:min_patients]) 
write_output(cluster_genes2, options[:output_file])

