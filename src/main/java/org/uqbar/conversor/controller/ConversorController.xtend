package org.uqbar.conversor.controller

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ModelAttribute
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.servlet.mvc.support.RedirectAttributes
import org.uqbar.domain.Conversor

@Controller
class ConversorController {

	@GetMapping("/")
	def redirectToConversor() {
		return 'redirect:/conversor'
	}

	@GetMapping("/conversor")
	def index(Model model) {
		model.addAttribute(model.getAttribute("conversor") ?: new Conversor())
		return 'conversor'
	}

	@PostMapping("/convertir")
	def convertir(@ModelAttribute("millas") Integer _millas, Model model, RedirectAttributes redirectAttributes) {
		val conversor = new Conversor => [millas = _millas]
		redirectAttributes.addFlashAttribute(conversor) // addFlashAttribute me permite guardar un objeto y addAttribute solo primitivos
		redirectToConversor
	}

}
