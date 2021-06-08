#!/usr/bin/env ruby

def load_clusters(clusters_file)
	cluster_pat = {}
	File.open(clusters_file).each do |line|
		line = line.chomp.split("\t")
		cluster_pat[line[1]] = [] if  cluster_pat[line[1]].nil?
		cluster_pat[line[1]] << line[0]
	end
	return cluster_pat
end

def load_and_filter_paco(paco_file, patients_to_filter)
	counter = 0
	patinet_index = {}
	File.open(paco_file).each_with_index do |line, i|
		line = line.chomp.split("\t")
		next if !patients_to_filter.include?(line[0]) && i > 0
		if patinet_index[line[0]].nil?
			patinet_index[line[0]] = counter
			counter +=1
		end
		line[0] = patinet_index[line[0]] if i != 0
		puts line.join("\t")
	end
end


paco_file = ARGV[0]
clusters_file = ARGV[1]
cluster_to_filter = ARGV[2]

cluster_patients = load_clusters(clusters_file)
patients_to_filter = cluster_patients[cluster_to_filter]
load_and_filter_paco(paco_file, patients_to_filter)

