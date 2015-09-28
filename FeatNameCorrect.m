function FeatNames = FeatNameCorrect(feats)

    feats = strrep(feats,'mean','Mean:');
    feats = strrep(feats,'min','Min:');
    feats = strrep(feats,'max','Max:');
    feats = strrep(feats,'std','Standard Deviation:');
    feats = strrep(feats,'range','Range:');
    feats = strrep(feats,'tss','SS:');
    feats = strrep(feats,'rms','RMS:');
    feats = strrep(feats,'pc1 X Forces','Principle Component 1');
    feats = strrep(feats,'pc2 X Forces','Principle Component 2');
    feats = strrep(feats,'pc3 X Forces','Principle Component 3');
    feats = strrep(feats,'log_total_time X Forces','Time: $\log(\text{Total Time})$');
    feats = strrep(feats,'sqrt_total_time X Forces','Time: $\sqrt{\text{Total Time}}$');
    feats = strrep(feats,'log_time X Forces','Time: $\log(\text{Active Time})$');
    feats = strrep(feats,'sqrt_time X Forces','Time: $\sqrt{\text{Active Time}}$');
    feats = strrep(feats,'total_time X Forces','Time: Total');
    feats = strrep(feats,'time X Forces','Time: Active');
    feats = strrep(feats,'counts1','Threshold (Lower) Count:');
    feats = strrep(feats,'counts2','Threshold (Upper) Count:');
   
    FeatNames = feats;
end