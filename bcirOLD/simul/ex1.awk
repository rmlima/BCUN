'NF == 4 { sum[$1] += $4; N[$1]++ } 
          END     { for (key in sum) {
                        avg = sum[key] / N[key];
                        printf "%s %f\n", key, avg;
                    } }' filename | sort
