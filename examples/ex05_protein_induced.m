classdef ex05_protein_induced
	% This file was automatically generated by OneModel.
	% Any changes you make to it will be overwritten the next time
	% the file is generated.

	properties
		p      % Default model parameters.
		x0     % Default initial conditions.
		M      % Mass matrix for DAE systems.
		opts   % Simulation options.
	end

	methods
		function obj = ex05_protein_induced()
			%% Constructor of ex05_protein_induced.
			obj.p    = obj.default_parameters();
			obj.x0   = obj.initial_conditions();
			obj.M    = obj.mass_matrix();
			obj.opts = obj.simulation_options();
		end

		function p = default_parameters(~)
			%% Default parameters value.
			p = [];
			p.A__k_m = 1.0;
			p.A__d_m = 1.0;
			p.A__k_p = 1.0;
			p.A__d_p = 1.0;
			p.B__d_m = 1.0;
			p.B__k_p = 1.0;
			p.B__d_p = 1.0;
			p.B__h = 1.0;
			p.B__k_m_max = 1.0;
		end

		function x0 = initial_conditions(~)
			%% Default initial conditions.
			x0 = [
				0.0 % A__mRNA
				0.0 % A__protein
				0.0 % B__mRNA
				0.0 % B__protein
			];
		end

		function M = mass_matrix(~)
			%% Mass matrix for DAE systems.
			M = [
				1 0 0 0 
				0 1 0 0 
				0 0 1 0 
				0 0 0 1 
			];
		end

		function opts = simulation_options(~)
			%% Default simulation options.
			opts.t_end = 10.0;
			opts.t_init = 0.0;
		end

		function dx = ode(~,t,x,p)
			%% Evaluate the ODE.
			%
			% Args:
			%	 t Current time in the simulation.
			%	 x Array with the state value.
			%	 p Struct with the parameters.
			%
			% Return:
			%	 dx Array with the ODE.

			% ODE and algebraic states:
			A__mRNA = x(1,:);
			A__protein = x(2,:);
			B__mRNA = x(3,:);
			B__protein = x(4,:);

			% Assigment states:
			B__TF = A__protein;
			B__k_m = p.B__k_m_max.*B__TF./(B__TF + p.B__h);

			% der(A__mRNA)
			dx(1,1) =  + (p.A__k_m) - (p.A__d_m.*A__mRNA) + (p.A__k_p.*A__mRNA) - (p.A__k_p.*A__mRNA);

			% der(A__protein)
			dx(2,1) =  + (p.A__k_p.*A__mRNA) - (p.A__d_p.*A__protein);

			% der(B__mRNA)
			dx(3,1) =  + (B__k_m) - (p.B__d_m.*B__mRNA) + (p.B__k_p.*B__mRNA) - (p.B__k_p.*B__mRNA);

			% der(B__protein)
			dx(4,1) =  + (p.B__k_p.*B__mRNA) - (p.B__d_p.*B__protein);

		end
		function out = simout2struct(~,t,x,p)
			%% Convert the simulation output into an easy-to-use struct.

			% We need to transpose state matrix.
			x = x';
			% ODE and algebraic states:
			A__mRNA = x(1,:);
			A__protein = x(2,:);
			B__mRNA = x(3,:);
			B__protein = x(4,:);

			% Assigment states:
			B__TF = A__protein;
			B__k_m = p.B__k_m_max.*B__TF./(B__TF + p.B__h);

			% Save simulation time.
			out.t = t;

			% Vector for extending single-value states and parameters.
			ones_t = ones(size(t'));


			% Save states.
			out.A__mRNA = (A__mRNA.*ones_t)';
			out.A__protein = (A__protein.*ones_t)';
			out.B__mRNA = (B__mRNA.*ones_t)';
			out.B__protein = (B__protein.*ones_t)';
			out.B__k_m = (B__k_m.*ones_t)';
			out.B__TF = (B__TF.*ones_t)';

			% Save parameters.
			out.A__k_m = (p.A__k_m.*ones_t)';
			out.A__d_m = (p.A__d_m.*ones_t)';
			out.A__k_p = (p.A__k_p.*ones_t)';
			out.A__d_p = (p.A__d_p.*ones_t)';
			out.B__d_m = (p.B__d_m.*ones_t)';
			out.B__k_p = (p.B__k_p.*ones_t)';
			out.B__d_p = (p.B__d_p.*ones_t)';
			out.B__h = (p.B__h.*ones_t)';
			out.B__k_m_max = (p.B__k_m_max.*ones_t)';

		end
		function plot(~,out)
			%% Plot simulation result.
			figure('Name','A');
			subplot(2,1,1);
			plot(out.t, out.A__mRNA);
			title("A__mRNA");
			ylim([0, +inf]);
			grid on;

			subplot(2,1,2);
			plot(out.t, out.A__protein);
			title("A__protein");
			ylim([0, +inf]);
			grid on;

			figure('Name','B');
			subplot(2,2,1);
			plot(out.t, out.B__mRNA);
			title("B__mRNA");
			ylim([0, +inf]);
			grid on;

			subplot(2,2,2);
			plot(out.t, out.B__protein);
			title("B__protein");
			ylim([0, +inf]);
			grid on;

			subplot(2,2,3);
			plot(out.t, out.B__k_m);
			title("B__k_m");
			ylim([0, +inf]);
			grid on;

			subplot(2,2,4);
			plot(out.t, out.B__TF);
			title("B__TF");
			ylim([0, +inf]);
			grid on;

		end
	end
end
