clc
clear
close all

n = 1000;
X = linspace(1,n,n);
Y = X;
Box_lowerbound = [1 1];
Box_upperbound = [n n];
Z = abs((peaks(n)*100));
% Z(Z<400) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Boundary Slice (Sub-boundary)
        %%%%
        slice = 5;
        %%%%

        Seed_bag_infor.Sub_Boundary = [];
        X_sub = linspace(X(1),X(end),slice+1);
        Y_sub = linspace(Y(1),Y(end),slice+1);
        Totle_slice =  slice^2;
        Sub_Boundary = zeros(Totle_slice,4);
        i = 1;
        for n = 1:size(X_sub,2)-1
            for nn = 1:size(Y_sub,2)-1
                Sub_Boundary(i,:) = round([X_sub(n), X_sub(n+1), Y_sub(nn), Y_sub(nn+1)]);
                i = i+1;
            end
        end
        Seed_bag_infor.Sub_Boundary = Sub_Boundary;

        %% Sub-boundary seeds spread
        %%%%
        seeds_per_bag = 5;
        %%%%
        Seed_bag_infor.Seed_bag = {};
        Dimension = 2;
        Seeds = zeros(seeds_per_bag,Dimension);
        for n = 1:size(Sub_Boundary,1)
            i = 1;
            for nn = [1,Dimension+1]
                Seed = randi([Sub_Boundary(n,nn), Sub_Boundary(n,nn+1)], seeds_per_bag, 1);
                Seeds(:,i) = Seed;
                i = i+1;
            end
            Seed_bag_infor.Seed_bag{n,1} = Seeds;
        end

        %% Scan & Rank Zoon
        Seed_bag_infor.Zoon_Score_Avg = [];

        for n = 1:size(Seed_bag_infor.Seed_bag,1)
            Zoon_Score = zeros(1,seeds_per_bag);
            for nn = 1:seeds_per_bag
                Seed_bag_infor.Seed_bag
                Zoon_Score(nn) = Z(Seed_bag_infor.Seed_bag{n}(nn,1),Seed_bag_infor.Seed_bag{n}(nn,2));
            end
            Seed_bag_infor.Zoon_Score_Avg = [Seed_bag_infor.Zoon_Score_Avg; mean(Zoon_Score)];
        end

        Score_sort = sort(Seed_bag_infor.Zoon_Score_Avg,'descend');

        Seed_bag_infor.Rank = [];
        iii = 1;
        for n = 1:size(Score_sort,1)
            index = find(Seed_bag_infor.Zoon_Score_Avg == Score_sort(n));
            if length(index)>1
                Seed_bag_infor.Rank(n:n+length(index)-1,1) = index;
                break
            end
            Seed_bag_infor.Rank(n,1) = index;
        end
        
        
        %%
        A = figure;
        surf(X,Y,Z','FaceAlpha',0.5);
        hold on
        for a = 2:slice
            line([X_sub(a),X_sub(a)],[Y(1),Y(end)],'Color','k','LineStyle','--')
            hold on
            line([X(1),X(end)],[Y_sub(a),Y_sub(a)],'Color','k','LineStyle','--')
            hold on
        end
        for b = 1:size(Seed_bag_infor.Seed_bag,1)
            plot(Seed_bag_infor.Seed_bag{b,1}(:,1),Seed_bag_infor.Seed_bag{b,1}(:,2),'*')
        end
        hold off
        shading interp
        colormap(jet)
        colorbar
        saveas(A,'A.png')

       %% Respread the seeds
        %%%%
        seed_num_max = 5;
        %%%%
        
        Seed_bag_infor.Seed_bag_2 = {};
        for k = 1:size(Score_sort,1)
            if seed_num_max-3*(k-1) == 0
                seed_num = 1;
            else
                seed_num = seed_num_max-2*(k-1);
            end
            i = 1;
            Seeds = zeros(seed_num,2);
            for nn = [1,Dimension+1]
                Seed = randi([Seed_bag_infor.Sub_Boundary(Seed_bag_infor.Rank(k),nn), Seed_bag_infor.Sub_Boundary(Seed_bag_infor.Rank(k),nn+1)], seed_num, 1);
                Seeds(:,i) = Seed;
                i = i+1;
            end
            Seed_bag_infor.Seed_bag_2{k,1} = Seeds;
        end
        %%
D = figure;
contourf(X,Y,Z',20);
hold on
for a = 2:slice
    line([X_sub(a),X_sub(a)],[Y(1),Y(end)],'Color','k','LineStyle','--')
    hold on
    line([X(1),X(end)],[Y_sub(a),Y_sub(a)],'Color','k','LineStyle','--')
    hold on
end
shading interp
colormap(jet)
colorbar
hold on
for a = 1:size(Seed_bag_infor.Seed_bag_2,1)
    plot(Seed_bag_infor.Seed_bag_2{a,1}(:,1),Seed_bag_infor.Seed_bag_2{a,1}(:,2),'o','color',[1.00,0.41,0.16],'MarkerFaceColor','w','MarkerSize',2.5)
    hold on
end
saveas(D,'D.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
B = figure;
contourf(X,Y,Z',20);
hold on
for a = 2:slice
    line([X_sub(a),X_sub(a)],[Y(1),Y(end)],'Color','k','LineStyle','--')
    hold on
    line([X(1),X(end)],[Y_sub(a),Y_sub(a)],'Color','k','LineStyle','--')
    hold on
end
shading interp
colormap(jet)
colorbar
hold on


All_seed.map = [];
All_seed.move = [];
All_seed.unmove = [];
All_seed.score = [];
for k = 1:size(Score_sort,1)
    %%%%
    % seed_num = 10;
%     seed=[700,1];
    % seed = ceil(rand(2,seed_num)*1000)';
    seed = Seed_bag_infor.Seed_bag_2{k};
    %%%%
    if isempty(seed)==1
        break
    end
    
    
    for j = 1:size(seed)
        step_num = 1;
        step_size = 10;
        seednow = seed(j,:);
        All_seed.map = [All_seed.map; seednow];
        All_seed.score = [All_seed.score; Z(seednow(1),seednow(2))];

    while step_num<100
    %     plot3(seednow(1),seednow(2),Z(seednow(1),seednow(2)'),'o','color',[1.00,0.41,0.16],'MarkerFaceColor','R','MarkerSize',2.5)
        plot(seednow(1),seednow(2),'o','color',[1.00,0.41,0.16],'MarkerFaceColor','w','MarkerSize',2.5)
        hold on

        score = Z(seednow(1),seednow(2));

        parameter_near = [seednow-step_size;seednow;seednow+step_size];
        score_near = zeros(size(parameter_near));
        for i = [1,3]
            for ii = 1:size(parameter_near,2)
                seed_near = seednow;
                seed_near(ii) = parameter_near(i,ii);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for n = 1:length(Box_lowerbound)
                    if seed_near(n)<Box_lowerbound(n) || seed_near(n)>Box_upperbound(n)
                        if (seed_near(n)-Box_lowerbound(n))<0
                            seed_near(n) = Box_lowerbound(n);
                        else
                            seed_near(n) = Box_upperbound(n);
                        end
                    end 
                end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                score_near(i,ii) = Z(seed_near(1),seed_near(2));
            end
        end
        score_near(2,:) = score.*ones(1,size(seednow,2));
        score_NowGradient = diff(score_near);
        score_next_direction = mean(score_NowGradient);

        if size(All_seed.map,1)>3
            if seednow == All_seed.map(size(All_seed.map,1)-2,:)
                step_size = step_size-1;
                if step_size>=1
                    continue
                else
                    break
                end
            end
        end  

        if norm(score_next_direction) == 0
            step_size = step_size-1;
            if step_size>=1
                continue
            else
                if step_num == 1
                 All_seed.unmove = [All_seed.unmove;seednow];
                end
                break
            end
        end

        seed_unit_direction = score_next_direction/norm(score_next_direction);
        seed_next = round(seednow + step_size*seed_unit_direction,3);
        for n = 1:length(Box_lowerbound)
            if seed_next(n)<Box_lowerbound(n) || seed_next(n)>Box_upperbound(n)
                if (seed_next(n)-Box_lowerbound(n))<0
                    seed_next(n) = Box_lowerbound(n);
                else
                    seed_next(n) = Box_upperbound(n);
                end
            end
        end

        if seed_next == seednow
           break
        end
        seednow = round(seed_next);

    %     if size(All_seed.map,1)>3
    %         if seednow == All_seed.map(size(All_seed.map,1)-1,:)
    %             break
    %         end
    %     end  

        All_seed.map = [All_seed.map;seednow];
        All_seed.score = [All_seed.score; Z(seednow(1),seednow(2))];
        pause(0.01)
        saveas(B,['',num2str(k),'-',num2str(j),'-',num2str(step_num),'.png'])


        step_num = step_num+1;

    end
        % saveas(B,['',num2str(j),'.png'])
        pause(1)
    end
end
hold off

seed_num = zeros(k-1,1);
for i = 1:k-1
    seed_num(i,1) = size(Seed_bag_infor.Seed_bag_2{i,1},1);
end
Total_seed = sum(seed_num);

%%
C = figure;
contourf(X,Y,Z',20);
hold on
for a = 2:slice
    line([X_sub(a),X_sub(a)],[Y(1),Y(end)],'Color','w','LineStyle','--')
    hold on
    line([X(1),X(end)],[Y_sub(a),Y_sub(a)],'Color','w','LineStyle','--')
    hold on
end
hold off
shading interp
colormap(jet)
hold on
plot(All_seed.map(:,1),All_seed.map(:,2),'*','color',[1.00,0.41,0.16],'MarkerFaceColor','w','MarkerSize',2.5)
hold on
plot(All_seed.unmove(:,1),All_seed.unmove(:,2),'o','color',[0.00,1.00,1.00],'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',4)
title(['Total Seed = ',num2str(Total_seed),'  Unmove = ',num2str(length(All_seed.unmove(:,1))),''])
saveas(C,'C.png')
