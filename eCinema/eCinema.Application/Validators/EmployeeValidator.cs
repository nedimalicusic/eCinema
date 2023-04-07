using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class EmployeeValidator : AbstractValidator<EmployeeUpsertDto>
    {
        public EmployeeValidator()
        {
            RuleFor(c => c.FirstName).NotEmpty().NotNull();
            RuleFor(c => c.LastName).NotEmpty().NotNull();
            RuleFor(c => c.Email).NotEmpty().NotNull();
            RuleFor(c => c.BirthDate).NotNull();
            RuleFor(c => c.Gender).NotNull();
            RuleFor(c => c.isActive).NotNull();
            RuleFor(c => c.CinemaId).NotNull();
        }
    }
}
