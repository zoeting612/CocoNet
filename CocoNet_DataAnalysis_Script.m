%between table columns initialized (22 subjects)
subID = [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22];
y1 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];      %past A
y2 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];      %past B
y3 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];      %past C
y4 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];     %past AB
y5 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];     %past AC
y6 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];     %past BC
y7 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];          %future A
y8 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];          %future B
y9 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];          %future C
y10 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];        %future AB
y11 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];        %future AC
y12 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];        %future BC
y13 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];        %ToM A
y14 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];        %ToM B
y15 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];        %ToM C
y16 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];      %ToM AB
y17 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];      %ToM AB
y18 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];      %ToM BC

%create between table 
for s=1:22
    if s<10
        sub = strcat('00',int2str(s));
    else
        sub = strcat('0',int2str(s));
    end

    for j=1:3
        condition  = strcat('00',int2str(j));
        if j==1 %past
            matrix_file = load(strcat('/data/tingz/Desktop/SprengDataset/MeanMatrices/Past/mean_matrix_',sub,'_',condition,'.mat'));
            matrix = matrix_file.mean_matrix;
            A = matrix(1,1);
            y1(s) = A;
            B = matrix(2,2);
            y2(s) = B;
            C = matrix(3,3);
            y3(s) = C;
            AB = matrix(1,2);
            y4(s) = AB;
            AC = matrix(1,3);
            y5(s) = AC;
            BC = matrix(2,3);
            y6(s) = BC;
        
        elseif j==2 %future
            matrix_file = load(strcat('/data/tingz/Desktop/SprengDataset/MeanMatrices/Future/mean_matrix_',sub,'_',condition,'.mat'));
            matrix = matrix_file.mean_matrix;
            A = matrix(1,1);
            y7(s) = A;
            B = matrix(2,2);
            y8(s) = B;
            C = matrix(3,3);
            y9(s) = C;
            AB = matrix(1,2);
            y10(s) = AB;
            AC = matrix(1,3);
            y11(s) = AC;
            BC = matrix(2,3);
            y12(s) = BC;
   
        else %j==3 ToM
            matrix_file = load(strcat('/data/tingz/Desktop/SprengDataset/MeanMatrices/Other/mean_matrix_',sub,'_',condition,'.mat'));
            matrix = matrix_file.mean_matrix;
            A = matrix(1,1);
            y13(s) = A;
            B = matrix(2,2);
            y14(s) = B;
            C = matrix(3,3);
            y15(s) = C;
            AB = matrix(1,2);
            y16(s) = AB;
            AC = matrix(1,3);
            y17(s) = AC;
            BC = matrix(2,3);
            y18(s) = BC;
        end
    end
end

between = table(subID,y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15, y16, y17, y18);

%within table columns
Connection = ["A"; "B"; "C"; "AB"; "AC"; "BC"; "A"; "B"; "C"; "AB"; "AC"; "BC"; "A"; "B"; "C"; "AB"; "AC"; "BC"];
Task = ["Past"; "Past";"Past"; "Past"; "Past"; "Past"; "Future"; "Future"; "Future"; "Future"; "Future"; "Future"; "ToM"; "ToM"; "ToM"; "ToM"; "ToM"; "ToM"];

%within table 
within = table(Connection, Task);

%anova
fit = fitrm(between,'y1-y18~1','WithinDesign',within);

anova = ranova(fit,'WithinModel','Task*Connection')

plotprofile(fit,'Connection','Group','Task')

%self vs nonself t test (mean of past and future compared to tom)

self_A = (y1+y7)/2;  %(past _A+ future_A)/2
self_B = (y2+y8)/2;
self_C = (y3+y9)/2;
self_AB = (y4+y10)/2;
self_AC = (y5+y11)/2;
self_BC = (y6+y12)/2;
non_self_A = y13;
non_self_B = y14;
non_self_C = y15;
non_self_AB = y16;
non_self_AC = y17;
non_self_BC = y18;

%self vs nonself table

self_nonself = table(subID,self_A,self_B,self_C, self_AB, self_AC, self_BC,non_self_A, non_self_B,non_self_C,non_self_AB,non_self_AC,non_self_BC);

%t test to see if DMN-B is more for nonself than self 
x = non_self_B;
y = self_B;
[h_B,p_B] = ttest(x,y)

%ttest to see if DMN-C is more for self than nonself
x_C = self_C;
y_C = non_self_C;
[h_s_C,p_s_C] = ttest(x_C,y_C)

% memory vs nonmemory ttest for DMN-C
memory_C = y3;
fut_C = y9;
tom_C = y15;
non_mem_C = (y9+y15)/2;

%ttest to see if DMN-C is more for memory than non-memory 
ttest_mem_fut = ttest(memory_C,fut_C);
ttest_mem_tom = ttest(memory_C,tom_C);
[h_m_C,p_m_C] = ttest(memory_C,non_mem_C)

