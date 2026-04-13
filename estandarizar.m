function MDtest_std=estandarizar(MDtrain,MDtest)
    M_mu=mean(MDtrain);
    M_tita=std(MDtrain);
    MDtest_std=(MDtest-repmat(M_mu,size(MDtest,1),1))./repmat(M_tita,size(MDtest,1),1);
end