#!/usr/bin/env ruby

########################################################
## initialize
########################################################
require 'optparse'

########################################################
##functions
########################################################


def load_and_parse_gtf(gmt_file)
	parsed_gtf = {}
	File.open(gmt_file).each do |line|
		line.chomp!
		next if line =~ /^#/
		line = line.split("\t")
		chr, source, gene_type, start, stop, score, strand, frame, attribute = line
		next if gene_type != "gene"
		#attribute is a unparsed string like 'gene_id "ENSG00000223972.5"; gene_type "transcribed_unprocessed_pseudogene"; gene_name "DDX11L1"; level 2; hgnc_id "HGNC:37102"; havana_gene "OTTHUMG00000000961.2";'
		attribute.gsub!(/\"|\"/, '')
		chr = chr.gsub("chr", "").to_i
		gene_id_attr = attribute.split(";").first
		ensbl_id = gene_id_attr.split(" ").last.split(".").first
		parsed_gtf[chr] = [] if parsed_gtf[chr].nil?
		parsed_gtf[chr] << [start.to_i, stop.to_i, ensbl_id]
	end
	return parsed_gtf
end


def load_and_parse_regions(regions_file)
	patient_regions = {}
	# PACO files: patient_id	chr	start	end	phenotypes
	File.open(regions_file).each_with_index do |line, line_n|
		next if line_n == 0 
		line = line.chomp.split("\t")
		patient_id, chr, start, stop, phenotypes = line
		next if chr == "-"
		patient_regions[patient_id] = [] if patient_regions[patient_id].nil?
		patient_regions[patient_id] << [chr.to_i, start.to_i, stop.to_i]
	end
	return patient_regions
end


def annotate_regions(parsed_gtf, all_regions)
	patient_genes = {}
	all_regions.each do |patient_id, regions|
		patient_id = patient_id.to_sym
		patient_genes[patient_id] = [] if patient_genes[patient_id].nil?
		regions.each do |chr, reg_start, reg_end|
			reg_coords = [reg_start, reg_end]
			chrom_regions = parsed_gtf[chr]
			chrom_regions.each do |gene_start, gene_stop, ensembl_id|
				gene_coords = [gene_start, gene_stop]
				patient_genes[patient_id] << ensembl_id if region_overlap(gene_coords, reg_coords)
			end
		end
	end
	return patient_genes
end

def region_overlap(reference_coords, case_coords)
	overlap_bool = (case_coords[0] >= reference_coords[0] && 
		             case_coords[1] <= reference_coords[1] ) ||
   
                     case_coords[0].between?(reference_coords[0], reference_coords[1]) || 
		
                     case_coords[1].between?(reference_coords[0], reference_coords[1]) ||
                     
                     ( case_coords[0] < reference_coords[0] && 
                     case_coords[1] > reference_coords[1] )
	return overlap_bool
end

def write_output(patient_genes, output_file)
	File.open(output_file, 'w') do |outfile|
		patient_genes.each do |patient_id, genes|
			next if genes.empty?
			outfile.puts "#{patient_id}\t#{genes.join(",")}"
		end
	end
end

########################################################
## options
########################################################
options = {}
OptionParser.new do |opts|

  options[:annotation_file] = nil
  opts.on("-g", "--gtf GTF_file", "Set GTF file") do |data|
    options[:annotation_file] = data
  end

  options[:input_file] = nil
  opts.on("-i PATH", "--input_file PATH", "Input file with regions data") do |data|
    options[:input_file] = data
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

parsed_gtf = load_and_parse_gtf(options[:annotation_file])

parsed_regions = load_and_parse_regions(options[:input_file])

patient_genes = annotate_regions(parsed_gtf, parsed_regions)

write_output(patient_genes, options[:output_file])