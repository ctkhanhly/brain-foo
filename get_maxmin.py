from BF_code_gen import cost, best, run

run()
print(max(map(lambda x: cost(*x), best)))
print(min(map(lambda x: cost(*x), best)))