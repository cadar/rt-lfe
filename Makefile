LFE_PATH=/home/cadar/lfe0.2/

all:
	@echo
	@erl -noshell -pa ${LFE_PATH} -eval 'code:load_file(lfe_comp).' -eval 'case lfe_comp:file(hd(init:get_plain_arguments())) of {error,X,AR} -> io:format("~p~n",[X]), halt(1) ; {ok,X,AR} -> io:format("~p ~p~n",[X,AR]), halt(0); X -> io:format("Compile error: ~p~n",[X]), halt(2) end.' \
-extra demo.lfe

test:
	@echo
	@erl -noshell -pa ${LFE_PATH} \
-eval 'code:load_file(demo).' \
-eval 'case demo:start() of X->io:format("~p~n",[X]) end.' \
-s erlang halt

clean:
	@rm -f *.beam *.dump
