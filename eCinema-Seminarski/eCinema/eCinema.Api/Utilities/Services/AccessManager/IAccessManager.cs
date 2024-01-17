namespace eCinema.Api
{
    public interface IAccessManager
    {
        Task<AccessSignInResponseModel> SignInAsync(AccessSignInModel model, CancellationToken cancellationToken = default);
        Task SignUpAsync(AccessSignUpModel model, CancellationToken cancellationToken = default);
    }
}
