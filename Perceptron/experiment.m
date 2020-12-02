#!/usr/local/Cellar/octave/5.2.0_10/bin/octave -qf
if (nargin!=3)
	printf("Usage: ./experiment.m <data> <alphas> <bes>\n");
	exit(1);
end

arg_list=argv();
data=arg_list{1};
as=str2num(arg_list{2});
bs=str2num(arg_list{3});
load(data); [N,L]=size(data); D=L-1;
ll=unique(data(:,L)); C=numel(ll);
rand("seed",23); data=data(randperm(N),:);
Ntr=round(.7*N); M=N-Ntr; te=data(Ntr+1:N,:);

printf("#      a       b   E   k Ete Ete (p)   Ite  (p)\n");
printf("#_______ _______ ___ ___ ___ _______ __________\n")
for a=as
	for b=bs
		[w,E,k]=perceptron(data(1:Ntr,:),b,a); rl=zeros(M,1);
		for n=1:M rl(n)=ll(linmach(w,[1 te(n,1:D)]')); end;
		[nerr m]=confus(te(:,L),rl) ;
		etep=nerr/M;
		s=sqrt(etep*(1-etep)/M);
		r=1.96*s;
		printf("%8.1f %7.1f %3d %3d %3d %7.1f [%3.1f, %3.1f] \n",a,b,E,k,nerr,etep*100,(etep-r)*100,(etep+r)*100);
		end;
end;