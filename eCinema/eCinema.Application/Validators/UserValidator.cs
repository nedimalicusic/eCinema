using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class UserValidator : AbstractValidator<UserUpserDto>
    {
        public UserValidator()
        {
            RuleFor(c => c.FirstName).NotNull().NotEmpty();
            RuleFor(c => c.LastName).NotNull().NotEmpty();
            RuleFor(c => c.Email).NotNull().NotEmpty();
            RuleFor(c => c.PhoneNumber).NotNull().NotEmpty();

            RuleFor(c => c.Password)
                .NotNull()
                .NotEmpty()
                .MinimumLength(8)
                .Matches(@"[A-Z]+")
                .Matches(@"[a-z]+")
                .Matches(@"[0-9]+")
                .When(u => u.Id == null || u.Password != null);

            RuleFor(c => c.Gender).NotNull();
            RuleFor(c => c.BirthDate).NotNull();
            RuleFor(c => c.Role).NotNull();
            RuleFor(c => c.IsActive).NotNull();
            RuleFor(c => c.IsVerified).NotNull();
            RuleFor(c => c.CityId).NotNull();
        }
    }
}
