using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ActorsValidator : AbstractValidator<ActorsUpsertDto>
    {
        public ActorsValidator()
        {
            RuleFor(c => c.FirstName).NotEmpty().NotNull();
            RuleFor(c => c.LastName).NotEmpty().NotNull();
            RuleFor(c => c.Email).NotEmpty().NotNull();
            RuleFor(c => c.BirthDate).NotNull();
            RuleFor(c => c.Gender).NotNull();
        }
    }
}
