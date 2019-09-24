function gen_excel(filedir)

global RES

for dep = 1:2
    switch dep
        case 1
            SrNo = RES{dep}.data(:,1);
            Events = RES{dep}.event_seq;
            Probability = RES{dep}.data(:,2);
            TSM_i1 = RES{dep}.data(:,3);
            TSM_i2 = RES{dep}.data(:,4);
            TSM_i3 = RES{dep}.data(:,5);
            CCT_i1 = RES{dep}.data(:,6);
            CCT_i2 = RES{dep}.data(:,7);
            CCT_i3 = RES{dep}.data(:,8);
            RM_i1 = RES{dep}.data(:,9);
            RM_i2 = RES{dep}.data(:,10);
            RM_i3 = RES{dep}.data(:,11);
            LSM_i1 = RES{dep}.data(:,12);
            LSM_i2 = RES{dep}.data(:,13);
            LSM_i3 = RES{dep}.data(:,14);
%             nTSM_i1 = RES{dep}.data(:,12);
%             nTSM_i2 = RES{dep}.data(:,13);
%             nTSM_i3 = RES{dep}.data(:,14);
%             nCCT_i1 = RES{dep}.data(:,15);
%             nCCT_i2 = RES{dep}.data(:,16);
%             nCCT_i3 = RES{dep}.data(:,17);
%             nLSM_i1 = RES{dep}.data(:,18);
%             nLSM_i2 = RES{dep}.data(:,19);
%             nLSM_i3 = RES{dep}.data(:,20);

            TSMhat_i = RES{dep}.data(:,15);
            CCThat_i = RES{dep}.data(:,16);
            RMhat_i = RES{dep}.data(:,17);
            LSMhat_i = RES{dep}.data(:,18);
            LLhat_i = RES{dep}.data(:,19);
%             RThat_i = RES{dep}.data(:,25);            
            Resilience_i = RES{dep}.data(:,20);
            [TSM_i1,TSM_i2,TSM_i3,CCT_i1,CCT_i2,CCT_i3,RM_i1,RM_i2,RM_i3,LSM_i1,LSM_i2,LSM_i3] = cellTSMCCTLSM(TSM_i1,TSM_i2,TSM_i3,CCT_i1,CCT_i2,CCT_i3,RM_i1,RM_i2,RM_i3,LSM_i1,LSM_i2,LSM_i3);
            T = table(SrNo,Events,Probability,TSM_i1,TSM_i2,TSM_i3,CCT_i1,CCT_i2,CCT_i3,RM_i1,RM_i2,RM_i3,LSM_i1,LSM_i2,LSM_i3,TSMhat_i,CCThat_i,RMhat_i,LSMhat_i,LLhat_i,Resilience_i);
            filename = strcat(filedir, '\resilience.xlsx');
            writetable(T,filename,'Sheet',1)
        case 2
            SrNo = RES{dep}.data(:,1);
            Events = RES{dep}.event_seq;
            Probability = RES{dep}.data(:,2);
            TSM1_i1 = RES{dep}.data(:,3);
            TSM1_i2 = RES{dep}.data(:,4);
            TSM1_i3 = RES{dep}.data(:,5);
            CCT1_i1 = RES{dep}.data(:,6);
            CCT1_i2 = RES{dep}.data(:,7);
            CCT1_i3 = RES{dep}.data(:,8);
            RM1_i1 = RES{dep}.data(:,9);
            RM1_i2 = RES{dep}.data(:,10);
            RM1_i3 = RES{dep}.data(:,11);
%             LSM1_i1 = RES{dep}.data(:,12);
%             LSM1_i2 = RES{dep}.data(:,13);
%             LSM1_i3 = RES{dep}.data(:,14);
%             nTSM1_i1 = RES{dep}.data(:,12);
%             nTSM1_i2 = RES{dep}.data(:,13);
%             nTSM1_i3 = RES{dep}.data(:,14);
%             nCCT1_i1 = RES{dep}.data(:,15);
%             nCCT1_i2 = RES{dep}.data(:,16);
%             nCCT1_i3 = RES{dep}.data(:,17);
%             nLSM1_i1 = RES{dep}.data(:,18);
%             nLSM1_i2 = RES{dep}.data(:,19);
%             nLSM1_i3 = RES{dep}.data(:,20);
            TSM2_i1 = RES{dep}.data(:,12);
            TSM2_i2 = RES{dep}.data(:,13);
            TSM2_i3 = RES{dep}.data(:,14);
            CCT2_i1 = RES{dep}.data(:,15);
            CCT2_i2 = RES{dep}.data(:,16);
            CCT2_i3 = RES{dep}.data(:,17);
            RM2_i1 = RES{dep}.data(:,18);
            RM2_i2 = RES{dep}.data(:,19);
            RM2_i3 = RES{dep}.data(:,20);
            LSM2_i1 = RES{dep}.data(:,21);
            LSM2_i2 = RES{dep}.data(:,22);
            LSM2_i3 = RES{dep}.data(:,23);
%             nTSM2_i1 = RES{dep}.data(:,30);
%             nTSM2_i2 = RES{dep}.data(:,31);
%             nTSM2_i3 = RES{dep}.data(:,32);
%             nCCT2_i1 = RES{dep}.data(:,33);
%             nCCT2_i2 = RES{dep}.data(:,34);
%             nCCT2_i3 = RES{dep}.data(:,35);
%             nLSM2_i1 = RES{dep}.data(:,36);
%             nLSM2_i2 = RES{dep}.data(:,37);
%             nLSM2_i3 = RES{dep}.data(:,38);        

            TSMhat_i = RES{dep}.data(:,24);
            CCThat_i = RES{dep}.data(:,25);
            RMhat_i = RES{dep}.data(:,26);
            LSMhat_i = RES{dep}.data(:,27);
            LLhat_i = RES{dep}.data(:,28);
%             RThat_i = RES{dep}.data(:,29);
            Resilience_i = RES{dep}.data(:,29);
            [TSM1_i1,TSM1_i2,TSM1_i3,CCT1_i1,CCT1_i2,CCT1_i3,RM1_i1,RM1_i2,RM1_i3,TSM2_i1,TSM2_i2,TSM2_i3,CCT2_i1,CCT2_i2,CCT2_i3,RM2_i1,RM2_i2,RM2_i3,LSM2_i1,LSM2_i2,LSM2_i3] = cellTSMCCTLSM(TSM1_i1,TSM1_i2,TSM1_i3,CCT1_i1,CCT1_i2,CCT1_i3,RM1_i1,RM1_i2,RM1_i3,TSM2_i1,TSM2_i2,TSM2_i3,CCT2_i1,CCT2_i2,CCT2_i3,RM2_i1,RM2_i2,RM2_i3,LSM2_i1,LSM2_i2,LSM2_i3);
            T = table(SrNo,Events,Probability,TSM1_i1,TSM1_i2,TSM1_i3,CCT1_i1,CCT1_i2,CCT1_i3,RM1_i1,RM1_i2,RM1_i3,TSM2_i1,TSM2_i2,TSM2_i3,CCT2_i1,CCT2_i2,CCT2_i3,RM2_i1,RM2_i2,RM2_i3,LSM2_i1,LSM2_i2,LSM2_i3,TSMhat_i,CCThat_i,RMhat_i,LSMhat_i,LLhat_i,Resilience_i);
            writetable(T,filename,'Sheet',2)
    end
end
            
            