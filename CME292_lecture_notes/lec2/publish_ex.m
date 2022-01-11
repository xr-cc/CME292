%Publish code
publish('demo_publish.m','pdf')

%Publish function
opts.evalCode = false;
publish('trap_rule.m', opts)