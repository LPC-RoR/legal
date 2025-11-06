class ClssActvdd
	def self.tipo(key)
		case key
		when 'd_jc', 'prprtr', 'unc'
			'Audiencia'
		when 'rnn'
			'Reunion'
		end
	end

	def self.actvdd
		{
			'd_jc'		=> 'Audiencia de juicio',
			'prprtr'	=> 'Audiencia preparatoria', 
			'unc'		=> 'Audiencia única'
		}
	end
end