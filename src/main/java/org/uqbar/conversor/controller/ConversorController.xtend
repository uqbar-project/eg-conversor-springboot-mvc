package org.uqbar.conversor.controller

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.servlet.mvc.support.RedirectAttributes
import org.uqbar.conversor.domain.Conversor

@Controller
class ConversorController {

	@GetMapping("/")
	def redirectToConversor() {
		return 'redirect:/conversor'
	}

	@GetMapping("/conversor")
	def index(Model model) {
		if (model.getAttribute("conversor") === null) {
			model.addAttribute(new Conversor)
		}
		return 'conversor'
	}

	@PostMapping("/convertir")
	def convertir(Conversor conversor, RedirectAttributes redirectAttributes) {
		redirectAttributes.addFlashAttribute(conversor) // addFlashAttribute me permite guardar un objeto y addAttribute solo primitivos
		redirectToConversor
	}

}
