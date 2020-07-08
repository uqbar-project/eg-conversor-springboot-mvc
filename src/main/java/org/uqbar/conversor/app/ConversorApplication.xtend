package org.uqbar.conversor.app

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.context.annotation.ComponentScan

@SpringBootApplication 
@ComponentScan(basePackages=#["org.uqbar.conversor"])
class ConversorApplication {
	def static void main(String[] args) {
		SpringApplication.run(ConversorApplication, args)
	}
}
