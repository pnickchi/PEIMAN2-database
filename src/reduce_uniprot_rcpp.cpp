#include <Rcpp.h>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

// [[Rcpp::export]]
void reduce_uniprot_rcpp(std::string infile, std::string outfile) {
  
  std::ifstream input(infile);
  if (!input.is_open()) Rcpp::stop("Cannot open input file: " + infile);
  
  std::ofstream output(outfile);
  if (!output.is_open()) Rcpp::stop("Cannot open output file: " + outfile);
  
  std::string line;
  std::vector<std::string> keep = {"AC", "OS", "KW", "FT"};
  
  while (std::getline(input, line)) {
    
    if (line.substr(0, 2) == "AC") {
      output << "ACHERE" << line << '\n';
    }

    if (line.substr(0, 2) == "OS") {
      output << "OSHERE" << line << '\n';
    }
    
    if (line.substr(0, 2) == "KW") {
      output << "KWHERE" << line << '\n';
    }
    
    if (line.substr(0, 2) == "FT") {
      output << "FTHERE" << line << '\n';
    }

    if (line.substr(0, 2) == "//") {
      output << "_" << line << "_" << '\n';
    }    

  }
  
  input.close();
  output.close();
  
}

